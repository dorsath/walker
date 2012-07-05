@start = ->
  new Tanks

class @Tanks
  #set objects to draw
  #set keyboard handles
  constructor: ->
    t = new TankModel
    @objects = []
    @objects[objects.length] = t.loadTank
    console.log(@objects)
    start_gl()

class @TankModel
  loadTank: ->
    cubeVerticesBuffer = gl.createBuffer()

    gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesBuffer)

    vertices = [
      #front
      -1.0, -1.0,  1.0,
       1.0, -1.0,  1.0,
       1.0,  1.0,  1.0,
      -1.0,  1.0,  1.0,
      #back
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
       1.0,  1.0, -1.0,
       1.0, -1.0, -1.0,
    ]

    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)

    colors = [
      [1.0,  1.0,  1.0,  1.0],    # Front face: white
      [1.0,  0.0,  0.0,  1.0],    # Back face: red
      [0.0,  1.0,  0.0,  1.0],    # Top face: green
      [0.0,  0.0,  1.0,  1.0],    # Bottom face: blue
      [1.0,  1.0,  0.0,  1.0],    # Right face: yellow
      [1.0,  0.0,  1.0,  1.0]     # Left face: purple
    ]


    # var generatedColors = []

    # for (j=0; j<6; j++) {
    #   var c = colors[j]

    #   // Repeat each color four times for the four vertices of the face

    #   for (var i=0; i<4; i++) {
    #     generatedColors = generatedColors.concat(c);
    #   }
    # }

    # cubeVerticesColorBuffer = gl.createBuffer();
    # gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesColorBuffer);
    # gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(generatedColors), gl.STATIC_DRAW);

    cubeVerticesIndexBuffer = gl.createBuffer()
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, cubeVerticesIndexBuffer)

    cubeVertexIndices = [
      0, 3, 4, 4, 5, 3, # left
      1, 2, 6, 6, 7, 1, # right
      0, 1, 2, 2, 3, 0, # front
      4, 5, 6, 6, 7, 4, # back
      0, 1, 4, 7, 4, 1, # bottom
      2, 3, 5, 5, 6, 2  # top
    ]

    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER,
        new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW)

  drawTank: ->
    gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesBuffer)
    gl.vertexAttribPointer(vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0)

    gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesColorBuffer)
    gl.vertexAttribPointer(vertexColorAttribute, 4, gl.FLOAT, false, 0, 0)

    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, cubeVerticesIndexBuffer)
    setMatrixUniforms()
    gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0)
