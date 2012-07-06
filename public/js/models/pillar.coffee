class Pillar
  draw: ->
    @drawObject(data) for data in @data

  buffer: ->
    @data = (window.loaded_objects)

    @bufferObject(data) for data in @data

  drawPillar: ->
    # gl.mvTranslate([3,0,0])

    gl.bindBuffer(gl.ARRAY_BUFFER, @pillarVerticesBuffer);
    gl.vertexAttribPointer(gl.vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);


    gl.bindBuffer(gl.ARRAY_BUFFER, @cubeVerticesColorBuffer);
    gl.vertexAttribPointer(gl.vertexColorAttribute, 3, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, @pillarVerticesIndexBuffer);
    gl.setMatrixUniforms();
    gl.drawElements(gl.TRIANGLES, (@data.indices.length), gl.UNSIGNED_SHORT, 0);

  bufferPillar: ->
    @pillarVerticesBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, @pillarVerticesBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(@data.vertices), gl.STATIC_DRAW);

    generatedColors = [
      1, 0, 0,
      0, 1, 0,
      0, 0, 1,
      1, 1, 0
    ]
    # # console.log(generatedColors);
    @cubeVerticesColorBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, @cubeVerticesColorBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(generatedColors), gl.STATIC_DRAW);

    @pillarVerticesIndexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, @pillarVerticesIndexBuffer);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(@data.indices), gl.STATIC_DRAW);

  drawObject: (data) ->
    gl.bindBuffer(gl.ARRAY_BUFFER, data.verticesBuffer);
    gl.vertexAttribPointer(gl.vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ARRAY_BUFFER, data.verticesColorBuffer);
    gl.vertexAttribPointer(gl.vertexColorAttribute, 3, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, data.verticesIndexBuffer);
    gl.setMatrixUniforms();
    gl.drawElements(gl.TRIANGLES, (data.indices.length), gl.UNSIGNED_SHORT, 0);


  bufferObject: (data) ->
    data.verticesBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, data.verticesBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(data.vertices), gl.STATIC_DRAW);

    generatedColors = [
      1, 0, 0,
      0, 1, 0,
      0, 0, 1,
      1, 1, 0
    ]

    data.verticesColorBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, data.verticesColorBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(generatedColors), gl.STATIC_DRAW);


    data.verticesIndexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, data.verticesIndexBuffer);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(data.indices), gl.STATIC_DRAW);


window.pillar = Pillar

