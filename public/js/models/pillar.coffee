class Pillar
  draw: ->
    @drawPillar()

  buffer: ->
    @bufferPillar()

  drawPillar: ->

    gl.mvTranslate([3,0,0])

    gl.bindBuffer(gl.ARRAY_BUFFER, @pillarVerticesBuffer);
    gl.vertexAttribPointer(gl.vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, @pillarVerticesIndexBuffer);
    gl.setMatrixUniforms();
    gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0);

  bufferPillar: ->
    @pillarVerticesBuffer = gl.createBuffer();

    gl.bindBuffer(gl.ARRAY_BUFFER, @pillarVerticesBuffer);

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
    @pillarVerticesColorBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, @pillarVerticesColorBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(generatedColors), gl.STATIC_DRAW);

    @pillarVerticesIndexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, @pillarVerticesIndexBuffer);

    pillarVertexIndices = [
      0, 3, 4, 4, 5, 3, # left
      1, 2, 6, 6, 7, 1, # right
      0, 1, 2, 2, 3, 0, # front
      4, 5, 6, 6, 7, 4, # back
      0, 1, 4, 7, 4, 1, # bottom
      2, 3, 5, 5, 6, 2, # top
    ]

    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(pillarVertexIndices), gl.STATIC_DRAW);

window.pillar = Pillar

