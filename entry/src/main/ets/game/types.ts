export interface Point {
  x: number;
  y: number;
}

export interface Tile {
  id: number;
  position: Point;
  targetPosition: Point;
  isEmpty: boolean;
}

export interface PuzzleState {
  size: number;
  tiles: Tile[];
  emptyPosition: Point;
  moves: number;
  isComplete: boolean;
  isShuffled: boolean;
}

export type SwipeDirection = 'up' | 'down' | 'left' | 'right';
