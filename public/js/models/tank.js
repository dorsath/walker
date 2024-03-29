// Generated by CoffeeScript 1.3.3
(function() {

  this.TankModel = (function() {
    var drawTank, loadTank;

    function TankModel() {}

    loadTank = function() {
      var colors, cubeVertexIndices, cubeVerticesBuffer, cubeVerticesIndexBuffer, vertices;
      cubeVerticesBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesBuffer);
      vertices = [-1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, -1.0, -1.0];
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
      colors = [[1.0, 1.0, 1.0, 1.0], [1.0, 0.0, 0.0, 1.0], [0.0, 1.0, 0.0, 1.0], [0.0, 0.0, 1.0, 1.0], [1.0, 1.0, 0.0, 1.0], [1.0, 0.0, 1.0, 1.0]];
      cubeVerticesIndexBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, cubeVerticesIndexBuffer);
      cubeVertexIndices = [0, 3, 4, 4, 5, 3, 1, 2, 6, 6, 7, 1, 0, 1, 2, 2, 3, 0, 4, 5, 6, 6, 7, 4, 0, 1, 4, 7, 4, 1, 2, 3, 5, 5, 6, 2];
      return gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW);
    };

    drawTank = function() {
      gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesBuffer);
      gl.vertexAttribPointer(vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);
      gl.bindBuffer(gl.ARRAY_BUFFER, cubeVerticesColorBuffer);
      gl.vertexAttribPointer(vertexColorAttribute, 4, gl.FLOAT, false, 0, 0);
      gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, cubeVerticesIndexBuffer);
      setMatrixUniforms();
      return gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0);
    };

    return TankModel;

  })();

}).call(this);
