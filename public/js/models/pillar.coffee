class Pillar
  draw: ->
    @drawObject(data) for data in @data
    # @drawObject(@data[0])

  buffer: ->
    @data = (window.loaded_objects)

    console.log(@data)
    @bufferObject(data) for data in @data

  drawObject: (data) ->
    gl.bindBuffer(gl.ARRAY_BUFFER, data.verticesBuffer);
    gl.vertexAttribPointer(gl.vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ARRAY_BUFFER, data.verticesColorBuffer);
    gl.vertexAttribPointer(gl.vertexColorAttribute, 4, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, data.verticesIndexBuffer);
    gl.setMatrixUniforms();
    gl.drawElements(gl.TRIANGLES, data.indices.length, gl.UNSIGNED_SHORT, 0);


  bufferObject: (data) ->
    data.verticesBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, data.verticesBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(data.vertices), gl.STATIC_DRAW);

    generatedColors = []
    # console.log(data.material.effects.color) for n in [0..data.indices.length]
    generatedColors =  generatedColors.concat(data.material.effects.color) for n in [0..data.indices.length]

    data.verticesColorBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, data.verticesColorBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(generatedColors), gl.STATIC_DRAW);


    data.verticesIndexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, data.verticesIndexBuffer);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(data.indices), gl.STATIC_DRAW);


window.pillar = Pillar

