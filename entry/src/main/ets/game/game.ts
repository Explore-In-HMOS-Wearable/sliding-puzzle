import { Point, PuzzleState, Tile } from './types';

export function createPuzzle(size: number = 3): PuzzleState {
  const tiles: Tile[] = [];

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const id = y * size + x + 1;
      const isEmpty = id === size * size;

      tiles.push({
        id: isEmpty ? 0 : id,
        position: { x, y },
        targetPosition: { x, y },
        isEmpty
      });
    }
  }

  return shufflePuzzle({
    size,
    tiles,
    emptyPosition: { x: size - 1, y: size - 1 },
    moves: 0,
    isComplete: true,
    isShuffled: false
  });
}

export function shufflePuzzle(puzzle: PuzzleState, shuffleMoves: number = 100): PuzzleState {
  let newPuzzle = { ...puzzle };
  const directions = ['up', 'down', 'left', 'right'];

  for (let i = 0; i < shuffleMoves; i++) {
    const randomDirection = directions[Math.floor(Math.random() * directions.length)];
    const moveResult = moveTile(newPuzzle, randomDirection);
    if (moveResult) {
      newPuzzle = moveResult;
    }
  }

  return {
    ...newPuzzle,
    moves: 0,
    isComplete: false,
    isShuffled: true
  };
}

export function moveTile(puzzle: PuzzleState, direction: string): PuzzleState | null {
  const { emptyPosition, size } = puzzle;
  let targetPosition: Point;

  switch (direction) {
    case 'up':
      targetPosition = { x: emptyPosition.x, y: emptyPosition.y + 1 };
      break;
    case 'down':
      targetPosition = { x: emptyPosition.x, y: emptyPosition.y - 1 };
      break;
    case 'left':
      targetPosition = { x: emptyPosition.x + 1, y: emptyPosition.y };
      break;
    case 'right':
      targetPosition = { x: emptyPosition.x - 1, y: emptyPosition.y };
      break;
    default:
      return null;
  }

  if (targetPosition.x < 0 || targetPosition.x >= size ||
    targetPosition.y < 0 || targetPosition.y >= size) {
    return null;
  }

  const tileToMoveIndex = puzzle.tiles.findIndex(
    tile =>
    tile.position.x === targetPosition.x &&
      tile.position.y === targetPosition.y
  );

  if (tileToMoveIndex === -1) {
    return null;
  }

  const newTiles = [...puzzle.tiles];
  const tileToMove = { ...newTiles[tileToMoveIndex] };

  tileToMove.position = { ...emptyPosition };
  newTiles[tileToMoveIndex] = tileToMove;

  const newPuzzle: PuzzleState = {
    ...puzzle,
    tiles: newTiles,
    emptyPosition: targetPosition,
    moves: puzzle.moves + 1
  };

  newPuzzle.isComplete = checkComplete(newPuzzle);

  return newPuzzle;
}

export function moveTileByPosition(puzzle: PuzzleState, tilePosition: Point): PuzzleState | null {
  const { emptyPosition } = puzzle;
  const dx = Math.abs(tilePosition.x - emptyPosition.x);
  const dy = Math.abs(tilePosition.y - emptyPosition.y);

  if ((dx === 1 && dy === 0) || (dx === 0 && dy === 1)) {
    let direction: string;

    if (tilePosition.x > emptyPosition.x) {
      direction = 'left';
    } else if (tilePosition.x < emptyPosition.x) {
      direction =
        'right';
    } else if (tilePosition.y > emptyPosition.y) {
      direction = 'up';
    } else {
      direction = 'down';
    }

    return moveTile(puzzle, direction);
  }

  return null;
}

function checkComplete(puzzle: PuzzleState): boolean {
  return puzzle.tiles.every(tile => {
    if (tile.isEmpty) {
      return tile.position.x === puzzle.size - 1 && tile.position.y === puzzle.size - 1;
    }
    return tile.position.x === tile.targetPosition.x &&
      tile.position.y === tile.targetPosition.y;
  });
}
