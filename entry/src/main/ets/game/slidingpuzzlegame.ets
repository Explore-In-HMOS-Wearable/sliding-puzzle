import { createPuzzle, shufflePuzzle, } from './game';
import { COLORS, PUZZLE_CONFIG } from './constants';
import { PuzzleRenderer } from './puzzlerenderer';
import { PuzzleController } from './puzzlecontroller';
import { PuzzleState } from './types';

@Component
export struct SlidingPuzzleCanvas {
  @State private puzzle: PuzzleState = createPuzzle(PUZZLE_CONFIG.PUZZLE_SIZE);
  @State private showComplete: boolean = false;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private renderer: PuzzleRenderer = new PuzzleRenderer(this.context);
  private controller: PuzzleController = new PuzzleController(
    (puzzle: PuzzleState) => {
      this.puzzle = puzzle;
      if (puzzle.isComplete && puzzle.isShuffled) {
        this.showComplete = true;
        setTimeout(() => {
          this.puzzle = createPuzzle(PUZZLE_CONFIG.PUZZLE_SIZE)
          this.showComplete = false;
        }, 5000);
      }
    },
    this.renderer.getTileSize()
  );

  build() {
    RelativeContainer() {
      Column() {
        Text(`Moves: ${this.puzzle.moves}`)
          .fontSize(16)
          .height(32)
          .fontColor('#fff')
          .fontWeight(FontWeight.Medium)
          .textShadow({
            radius: 4,
            color: '#000',
          })

        Button('New Game')
          .onClick(() => {
            this.puzzle = shufflePuzzle(this.puzzle, PUZZLE_CONFIG.SHUFFLE_MOVES);
            this.showComplete = false;
          })
          .fontSize(14)
          .height(32)
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(10)
      .width(233)
      .height(233)


      Canvas(this.context)
        .borderRadius(6)
        .borderStyle(BorderStyle.Solid)
        .borderColor(COLORS.TILE_BORDER)
        .borderWidth(1)
        .position({
          left: PUZZLE_CONFIG.CANVAS_OFFSET,
          top: PUZZLE_CONFIG.CANVAS_OFFSET
        })
        .width(PUZZLE_CONFIG.CANVAS_SIZE)
        .height(PUZZLE_CONFIG.CANVAS_SIZE)
        .onReady(() => {
          this.startGame();
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Up) {
            const touch = event.touches[0];
            this.controller.handleTileTap(this.puzzle, touch.x, touch.y);
          }
        })
        .gesture(
          PanGesture({ fingers: 1, distance: 30 })
            .onActionEnd((event: GestureEvent) => {
              this.controller.handleGesture(this.puzzle, event);
            })
        )

      if (this.showComplete) {
        Column() {
          Text('🎊 CONGRATS! 🎊')
            .fontSize(20)
            .fontColor(COLORS.COMPLETE_TILE)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })

          Text(`Completed in ${this.puzzle.moves} moves!`)
            .fontSize(16)
            .fontColor(COLORS.TILE_TEXT)
        }
        .backgroundColor('rgba(0,0,0,0.9)')
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .backgroundColor('#fff')
    .width('100%')
    .height('100%')

    .linearGradient({
      angle: 145,
      colors: [[COLORS.GRADIENT_START, 0], [COLORS.GRADIENT_END, 1]]
    })
  }

  private startGame(): void {
    this.gameLoop();
  }

  private gameLoop(): void {
    this.renderer.drawPuzzle(this.puzzle);
    setTimeout(() => {
      this.gameLoop();
    }, 16);
  }
}