#include <stdlib.h>
#include "raylib.h"

int main()
{
  InitWindow(800, 600, "hello world");
  SetTargetFPS(60);

  while (!WindowShouldClose())
  {
    BeginDrawing();
      ClearBackground(SKYBLUE);
      DrawRectangle(400,300,30,30,BLACK);
    EndDrawing();
  }

  CloseWindow();
  return 0;
}
