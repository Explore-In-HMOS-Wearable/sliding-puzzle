import { COLORS, PUZZLE_CONFIG } from './constants';
import { PuzzleState, Tile } from './types';

export class PuzzleRenderer {
  private context: CanvasRenderingContext2D;
  private tileSize: number;

  constructor(context: CanvasRenderingContext2D) {
    this.context = context;
    this.tileSize = (PUZZLE_CONFIG.CANVAS_SIZE - (PUZZLE_CONFIG.PUZZLE_SIZE + 1) * PUZZLE_CONFIG.TILE_PADDING) /
    PUZZLE_CONFIG.PUZZLE_SIZE;
  }

  drawPuzzle(puzzle: PuzzleState): void {
    this.drawBackground();
    this.drawTiles(puzzle);
  }

  private drawBackground(): void {
    this.drawRoundedRect(0, 0, PUZZLE_CONFIG.CANVAS_SIZE, PUZZLE_CONFIG.CANVAS_SIZE, 6, COLORS.BACKGROUND);
  }

  private drawTiles(puzzle: PuzzleState): void {
    puzzle.tiles
      .filter(tile => !tile.isEmpty)
      .forEach(tile => {
        this.drawTile(tile, puzzle.isComplete);
      });
  }

  private drawTile(tile: Tile, isComplete: boolean): void {
    const x = tile.position.x * (this.tileSize + PUZZLE_CONFIG.TILE_PADDING) + PUZZLE_CONFIG.TILE_PADDING;
    const y = tile.position.y * (this.tileSize + PUZZLE_CONFIG.TILE_PADDING) + PUZZLE_CONFIG.TILE_PADDING;

    const isCorrectPosition = tile.position.x === tile.targetPosition.x &&
      tile.position.y === tile.targetPosition.y;

    const gradient = this.context.createLinearGradient(x, y, x + this.tileSize, y + this.tileSize);
    if (isComplete && isCorrectPosition) {
      gradient.addColorStop(0, COLORS.COMPLETE_TILE);
      gradient.addColorStop(1, '#1e8449');
    } else if (isCorrectPosition) {
      gradient.addColorStop(0, '#5dade2');
      gradient.addColorStop(1, COLORS.TILE_BACKGROUND);
    } else {
      gradient.addColorStop(0, COLORS.TILE_BACKGROUND);
      gradient.addColorStop(1, COLORS.TILE_BORDER);
    }

    this.drawRoundedRect(x, y, this.tileSize, this.tileSize, 4, COLORS.TILE_BACKGROUND);

    this.context.strokeStyle = isCorrectPosition ? '#2e7d32' : COLORS.TILE_BORDER;
    this.context.lineWidth = 1;
    this.drawRoundedRectStroke(x, y, this.tileSize, this.tileSize, 4);

    this.context.fillStyle = COLORS.TILE_TEXT;
    this.context.font = `bold ${this.tileSize}px`;
    this.context.textAlign = 'center';
    this.context.textBaseline = 'middle';
    this.context.fillText(
      tile.id.toString(),
      x + this.tileSize / 2,
      y + this.tileSize / 2
    );
  }

  private drawRoundedRect(x: number, y: number, width: number, height: number, radius: number,
    fillStyle: string): void {
    this.context.fillStyle = fillStyle;
    this.context.beginPath();
    this.context.moveTo(x + radius, y);
    this.context.lineTo(x + width - radius, y);
    this.context.quadraticCurveTo(x + width, y, x + width, y + radius);
    this.context.lineTo(x + width, y + height - radius);
    this.context.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
    this.context.lineTo(x + radius, y + height);
    this.context.quadraticCurveTo(x, y + height, x, y + height - radius);
    this.context.lineTo(x, y + radius);
    this.context.quadraticCurveTo(x, y, x + radius, y);
    this.context.closePath();
    this.context.fill();
  }

  private drawRoundedRectStroke(x: number, y: number, width: number, height: number, radius: number): void {
    this.context.beginPath();
    this.context.moveTo(x + radius, y);
    this.context.lineTo(x + width - radius, y);
    this.context.quadraticCurveTo(x + width, y, x + width, y + radius);
    this.context.lineTo(x + width, y + height - radius);
    this.context.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
    this.context.lineTo(x + radius, y + height);
    this.context.quadraticCurveTo(x, y + height, x, y + height - radius);
    this.context.lineTo(x, y + radius);
    this.context.quadraticCurveTo(x, y, x + radius, y);
    this.context.closePath();
    this.context.stroke();
  }

  getTileSize(): number {
    return this.tileSize;
  }
}
