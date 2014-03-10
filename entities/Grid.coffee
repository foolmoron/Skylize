Grid = IgeEntity.extend
    classId: 'Grid'
    
    init: (@_gridSize, @_tileSize) ->
        IgeEntity::init.call @

        @_grid = []
        for i in [1..15]
            column = []
            for j in [1..15]
                newTile = new Tile(@_tileSize)
                    .id("#{i}x#{j}")
                    .translateTo i * @_tileSize, j * @_tileSize, 0
                    .mount @
                column.push newTile

module.exports = Grid if module?.exports?