@start = ->
  canvas = document.getElementById("glcanvas");
  window.gl = canvas.getContext("experimental-webgl");

  gl.mvMatrix = Matrix.I(4)
  gl.perspectiveMatrix = Matrix.I(4)
  gl.mvMatrixStack = []

  gl.getShader=(gl, id) ->
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

  gl.initShaders= ->
    fragmentShader = @getShader(gl, "shader-fs");
    vertexShader = @getShader(gl, "shader-vs");

    @shaderProgram = gl.createProgram();
    gl.attachShader(@shaderProgram, vertexShader);
    gl.attachShader(@shaderProgram, fragmentShader);
    gl.linkProgram(@shaderProgram);

    if (!gl.getProgramParameter(@shaderProgram, gl.LINK_STATUS))
      alert("Unable to initialize the shader program.")

    gl.useProgram(@shaderProgram);

    @vertexPositionAttribute = gl.getAttribLocation(@shaderProgram, "aVertexPosition");
    gl.enableVertexAttribArray(@vertexPositionAttribute);

    vertexColorAttribute = gl.getAttribLocation(@shaderProgram, "aVertexColor");
    gl.enableVertexAttribArray(vertexColorAttribute);

  gl.loadIdentity= ->
    @mvMatrix = Matrix.I(4);
    @setMatrixUniforms()

  gl.multMatrix= (m) ->
    @mvMatrix = @mvMatrix.x(m);

  gl.mvTranslate= (v) ->
    @multMatrix(Matrix.Translation($V([v[0], v[1], v[2]])).ensure4x4());

  gl.setMatrixUniforms= ->
    pUniform = gl.getUniformLocation(@shaderProgram, "uPMatrix");
    gl.uniformMatrix4fv(pUniform, false, new Float32Array(@perspectiveMatrix.flatten()));
    mvUniform = gl.getUniformLocation(@shaderProgram, "uMVMatrix");
    gl.uniformMatrix4fv(mvUniform, false, new Float32Array(@mvMatrix.flatten()));

  gl.mvPushMatrix= (m) ->
    if (m)
      @mvMatrixStack.push(m.dup());
      @mvMatrix = m.dup();
    else
      @mvMatrixStack.push(@mvMatrix.dup());

  gl.mvPopMatrix= ->
      if (!@mvMatrixStack.length)
        throw("Can't pop from an empty matrix stack.")

      @mvMatrix = @mvMatrixStack.pop();
      return @mvMatrix;

  gl.mvRotate= (angle, v) ->
      inRadians = angle * Math.PI / 180.0;

      m = Matrix.Rotation(inRadians, $V([v[0], v[1], v[2]])).ensure4x4();
      gl.multMatrix(m);

  window.walker = new window.walker_object

