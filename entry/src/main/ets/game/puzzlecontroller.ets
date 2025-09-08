import { moveTile, moveTileByPosition, } from './game';
import { Point, PuzzleState, SwipeDirection } from './types';
import { PUZZLE_CONFIG } from './constants';

export class PuzzleController {
  private onGameUpdate: (puzzle: PuzzleState) => void;
  private tileSize: number;

  constructor(onGameUpdate: (puzzle: PuzzleState) => void, tileSize: number) {
    this.onGameUpdate = onGameUpdate;
    this.tileSize = tileSize;
  }

  handleTileTap(puzzle: PuzzleState, tapX: number, tapY: number): PuzzleState | null {
    const gridPosition = this.screenToGrid(tapX, tapY);
    if (!gridPosition) {
      return null;
    }

    const newPuzzle = moveTileByPosition(puzzle, gridPosition);
    if (newPuzzle) {
      this.onGameUpdate(newPuzzle);
      return newPuzzle;
    }
    return null;
  }

  handleSwipe(puzzle: PuzzleState, direction: SwipeDirection): PuzzleState | null {
    const newPuzzle = moveTile(puzzle, direction);
    if (newPuzzle) {
      this.onGameUpdate(newPuzzle);
      return newPuzzle;
    }
    return null;
  }

  handleGesture(puzzle: PuzzleState, event: GestureEvent): PuzzleState | null {
    const deltaX = event.offsetX;
    const deltaY = event.offsetY;
    let direction: SwipeDirection;

    if (Math.abs(deltaX) > Math.abs(deltaY)) {
      direction = deltaX > 0 ? 'right' : 'left';
    } else {
      direction = deltaY > 0 ? 'down' : 'up';
    }

    return this.handleSwipe(puzzle, direction);
  }

  private screenToGrid(screenX: number, screenY: number): Point | null {
    const gridX = Math.floor((screenX - PUZZLE_CONFIG.TILE_PADDING) / (this.tileSize + PUZZLE_CONFIG.TILE_PADDING));
    const gridY = Math.floor((screenY - PUZZLE_CONFIG.TILE_PADDING) / (this.tileSize + PUZZLE_CONFIG.TILE_PADDING));

    if (gridX >= 0 && gridX < PUZZLE_CONFIG.PUZZLE_SIZE &&
      gridY >= 0 && gridY < PUZZLE_CONFIG.PUZZLE_SIZE) {
      return { x: gridX, y: gridY };
    }
    return null;
  }
}