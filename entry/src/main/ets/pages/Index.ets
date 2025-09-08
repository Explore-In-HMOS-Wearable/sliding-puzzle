import { SlidingPuzzleCanvas } from '../game/slidingpuzzlegame';


@Entry
@Component
struct SlidingPuzzleGame {
  build() {
    RelativeContainer(){
      SlidingPuzzleCanvas()
    }
  }
}