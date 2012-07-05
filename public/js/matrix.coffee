root = exports ? @
root.shaderProgram;
root.perspectiveMatrix;
root.mvMatrix = Matrix.I(4)

root.setMatrixUniforms = (gl) ->
  pUniform = gl.getUniformLocation(root.shaderProgram, "uPMatrix")
  gl.uniformMatrix4fv(pUniform, false, new Float32Array(root.perspectiveMatrix.flatten()))

  mvUniform = gl.getUniformLocation(root.shaderProgram, "uMVMatrix")
  gl.uniformMatrix4fv(mvUniform, false, new Float32Array(root.mvMatrix.flatten()))

root.loadIdentity = ->
  root.mvMatrix = Matrix.I(4)

root.multMatrix = (m)->
  root.mvMatrix = root.mvMatrix.x(m)

root.mvTranslate = (v) ->
  multMatrix(Matrix.Translation($V([v[0], v[1], v[2]])).ensure4x4())

root.initShaders = (gl) ->
  fragmentShader = getShader(gl, "shader-fs")
  vertexShader = getShader(gl, "shader-vs")

  root.shaderProgram = gl.createProgram()
  gl.attachShader(root.shaderProgram, vertexShader)
  gl.attachShader(root.shaderProgram, fragmentShader)
  gl.linkProgram(root.shaderProgram)

  if (!gl.getProgramParameter(root.shaderProgram, gl.LINK_STATUS))
    alert("Unable to initialize the shader program.")

  gl.useProgram(root.shaderProgram)

  vertexPositionAttribute = gl.getAttribLocation(root.shaderProgram, "aVertexPosition")
  gl.enableVertexAttribArray(vertexPositionAttribute)

  vertexColorAttribute = gl.getAttribLocation(root.shaderProgram, "aVertexColor")
  gl.enableVertexAttribArray(vertexColorAttribute)


root.getShader =(gl, id) ->
  shaderScript = document.getElementById(id)

  if (!shaderScript)
    return null


  theSource = ""
  currentChild = shaderScript.firstChild

  while(currentChild)
    if (currentChild.nodeType == 3)
      theSource += currentChild.textContent;

    currentChild = currentChild.nextSibling;


  if (shaderScript.type == "x-shader/x-fragment")
    shader = gl.createShader(gl.FRAGMENT_SHADER)
  else if (shaderScript.type == "x-shader/x-vertex")
    shader = gl.createShader(gl.VERTEX_SHADER)
  else
    return

  gl.shaderSource(shader, theSource)

  gl.compileShader(shader)

  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS))
    alert("An error occurred compiling the shaders: " + gl.getShaderInfoLog(shader))
    return null

  return shader
