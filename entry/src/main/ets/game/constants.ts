const canvassize = (233 / Math.sqrt(2)) - 30;
const pad = ((233 - canvassize) / 2)

export const PUZZLE_CONFIG = {
  PUZZLE_SIZE: 3,
  CANVAS_SIZE: canvassize,
  CANVAS_OFFSET: pad,
  TILE_PADDING: 3,
  ANIMATION_DURATION: 200,
  SHUFFLE_MOVES: 100
};


export const COLORS = {
  BACKGROUND: '#EBEFF5',
  GRID_BORDER: '#993',
  TILE_BACKGROUND: '#fff',
  TILE_BORDER: '#357abd',
  TILE_TEXT: '#4682B4',
  EMPTY_SPACE: '#2a2a2a',
  COMPLETE_TILE: '#fff',
  GRADIENT_START: '#667eea',
  GRADIENT_END: '#764ba2'
};