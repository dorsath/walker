@start = ->
  window.walker = new Walker

class Walker
  constructor: ->
    @mvMatrixStack = []
    @mvMatrix = Matrix.I(4);

    @zoom = -5;
    @rotation = 45
    @currentlyPressedKeys = []
    @currentTime = (new Date).getTime()

    canvas = document.getElementById("glcanvas");
    document.onkeyup   = @handleKeyUp;
    document.onkeydown = @handleKeyDown;

    gl = canvas.getContext("experimental-webgl");

    if gl
      gl.clearColor(0.0, 0.0, 0.0, 1.0);  # Clear to black, fully opaque
      gl.clearDepth(1.0);                 # Clear everything
      gl.enable(gl.DEPTH_TEST);           # Enable depth testing
      gl.depthFunc(gl.LEQUAL);            # Near things obscure far things

      @initShaders(gl);

      @initBuffers(gl);
      # @drawScene(gl);

      setInterval(@drawLoop, 15, gl, @);

  drawLoop: (gl, scope) ->
    scope.drawScene(gl)

  handleKeyDown: (event) ->
    walker.currentlyPressedKeys[event.keyCode] = true

  handleKeyUp: (event) ->
    walker.currentlyPressedKeys[event.keyCode] = false

  handleKeys: ->
    if (@currentlyPressedKeys[37])
      @rotation -= 360*@dt();
    if (@currentlyPressedKeys[39])
      @rotation += 360*@dt();

    if (@currentlyPressedKeys[187])
      @zoom *= 0.9;
    if (@currentlyPressedKeys[189])
      @zoom *= 1.1;

  initBuffers: (gl)->



    @cubeVerticesBuffer = gl.createBuffer();

    gl.bindBuffer(gl.ARRAY_BUFFER, @cubeVerticesBuffer);

    vertices = [
      -1.0, -1.0,  1.0,
       1.0, -1.0,  1.0,
       1.0,  1.0,  1.0,
      -1.0,  1.0,  1.0,
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
       1.0,  1.0, -1.0,
       1.0, -1.0, -1.0
    ];

    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
#
#     colors = [
#       [1.0,  1.0,  1.0,  1.0],    # Front face: white
#       [1.0,  0.0,  0.0,  1.0],    # Back face: red
#       [0.0,  1.0,  0.0,  1.0],    # Top face: green
#       [0.0,  0.0,  1.0,  1.0],    # Bottom face: blue
#       [1.0,  1.0,  0.0,  1.0],    # Right face: yellow
#       [1.0,  0.0,  1.0,  1.0]     # Left face: purple
#     ];

    generatedColors = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1]
    # console.log(generatedColors);
    @cubeVerticesColorBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, @cubeVerticesColorBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(generatedColors), gl.STATIC_DRAW);

    @cubeVerticesIndexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, @cubeVerticesIndexBuffer);

    cubeVertexIndices = [
      0, 3, 4, 4, 5, 3, # left
      1, 2, 6, 6, 7, 1, # right
      0, 1, 2, 2, 3, 0, # front
      4, 5, 6, 6, 7, 4, # back
      0, 1, 4, 7, 4, 1, # bottom
      2, 3, 5, 5, 6, 2, # top
    ]

    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW);


  dt: ->
    return (((new Date).getTime() - @currentTime) / 1000);


  drawScene:(gl,scope) ->
    # this = scope
    @handleKeys();

    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    @perspectiveMatrix = makePerspective(45, 640.0/480.0, 0.1, 100.0);

    @loadIdentity();

    @mvTranslate([-0.0, 0.0, @zoom]);
    @mvRotate(45, [1, 0, 0]);
    @mvRotate(@rotation, [0, 1, 0]);

    @mvPushMatrix();
    @drawCube(gl);
    @mvPopMatrix();

    @currentTime = (new Date).getTime();

  drawCube:(gl) ->
    gl.bindBuffer(gl.ARRAY_BUFFER, @cubeVerticesBuffer);
    gl.vertexAttribPointer(@vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ARRAY_BUFFER, @cubeVerticesColorBuffer);
    gl.vertexAttribPointer(@vertexColorAttribute, 4, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, @cubeVerticesIndexBuffer);
    @setMatrixUniforms(gl);
    gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0);

  initShaders: (gl) ->
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

  getShader:(gl, id) ->
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

  loadIdentity: ->
    @mvMatrix = Matrix.I(4);

  multMatrix: (m) ->
    @mvMatrix = @mvMatrix.x(m);

  mvTranslate: (v) ->
    @multMatrix(Matrix.Translation($V([v[0], v[1], v[2]])).ensure4x4());

  setMatrixUniforms:(gl) ->
    pUniform = gl.getUniformLocation(@shaderProgram, "uPMatrix");
    gl.uniformMatrix4fv(pUniform, false, new Float32Array(@perspectiveMatrix.flatten()));

    mvUniform = gl.getUniformLocation(@shaderProgram, "uMVMatrix");
    gl.uniformMatrix4fv(mvUniform, false, new Float32Array(@mvMatrix.flatten()));

  mvPushMatrix: (m) ->
    if (m)
      @mvMatrixStack.push(m.dup());
      @mvMatrix = m.dup();
    else
      @mvMatrixStack.push(@mvMatrix.dup());

  mvPopMatrix:() ->
    if (!@mvMatrixStack.length)
      throw("Can't pop from an empty matrix stack.")

    @mvMatrix = @mvMatrixStack.pop();
    return @mvMatrix;

  mvRotate: (angle, v) ->
    inRadians = angle * Math.PI / 180.0;

    m = Matrix.Rotation(inRadians, $V([v[0], v[1], v[2]])).ensure4x4();
    @multMatrix(m);
