Grid = IgeEntity.extend
    classId: 'Grid'
    
    init: (@_gridSize, @_tileSize) ->
        IgeEntity::init.call @

        @_grid = []
        for i in [0..@_gridSize] # index at 0 to add extra column
            row = []
            for j in [0..@_gridSize] # index at 0 to add extra row
                newTile = new Tile(@_tileSize)
                    .id("#{i}x#{j}")
                    .translateTo i * @_tileSize, j * @_tileSize, 0
                    .depth i * @_gridSize + j
                    .mount @
                row.push newTile

                if i == @_gridSize && j == @_gridSize
                    for light of newTile._lights
                        newTile._lights[light].destroy()
                        delete newTile._lights[light]
                else if i == @_gridSize
                    for light of newTile._lights
                        if light != 'l'
                            newTile._lights[light].destroy()
                            delete newTile._lights[light]
                else if j == @_gridSize
                    for light of newTile._lights
                        if light != 't'
                            newTile._lights[light].destroy()
                            delete newTile._lights[light]

module.exports = Grid if module?.exports?