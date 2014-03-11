// Generated by CoffeeScript 1.7.1
var Grid;

Grid = IgeEntity.extend({
  classId: 'Grid',
  init: function(_gridSize, _tileSize) {
    var column, i, j, newTile, _i, _ref, _results;
    this._gridSize = _gridSize;
    this._tileSize = _tileSize;
    IgeEntity.prototype.init.call(this);
    this._grid = [];
    _results = [];
    for (i = _i = 1, _ref = this._gridSize; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
      column = [];
      _results.push((function() {
        var _j, _ref1, _results1;
        _results1 = [];
        for (j = _j = 1, _ref1 = this._gridSize; 1 <= _ref1 ? _j <= _ref1 : _j >= _ref1; j = 1 <= _ref1 ? ++_j : --_j) {
          newTile = new Tile(this._tileSize).id("" + i + "x" + j).translateTo(i * this._tileSize, j * this._tileSize, 0).mount(this);
          _results1.push(column.push(newTile));
        }
        return _results1;
      }).call(this));
    }
    return _results;
  }
});

if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
  module.exports = Grid;
}
