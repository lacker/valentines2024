<script>
  import { onMount, onDestroy } from "svelte";

  let grid = [
    ["A", "B", "C", "D"],
    ["E", "F", "G", "H"],
    ["I", "J", "K", "L"],
    ["M", "N", "O", "P"],
  ];

  // Apply gravity to "move the row to the start".
  // May be destructive.
  // Returns the new row.
  function apply_gravity_to_row(row) {
    return row.sort();
  }

  function copy_grid(g) {
    return g.map((row) => row.slice());
  }

  function left_gravity(g) {
    return copy_grid(g).map(apply_gravity_to_row);
  }

  function transpose_grid(g) {
    let answer = copy_grid(g);
    for (let i = 0; i < g.length; i++) {
      for (let j = 0; j < g.length; j++) {
        answer[i][j] = g[j][i];
      }
    }
    return answer;
  }

  function up_gravity(g) {
    g = transpose_grid(g);
    g = left_gravity(g);
    return transpose_grid(g);
  }

  function v_flip_grid(g) {
    return copy_grid(g).reverse();
  }

  function h_flip_grid(g) {
    return copy_grid(g).map((row) => row.reverse());
  }

  function down_gravity(g) {
    return v_flip_grid(up_gravity(v_flip_grid(g)));
  }

  function right_gravity(g) {
    return h_flip_grid(left_gravity(h_flip_grid(g)));
  }

  function handleUp() {
    grid = up_gravity(grid);
  }

  function handleDown() {
    grid = down_gravity(grid);
  }

  function handleLeft() {
    grid = left_gravity(grid);
  }

  function handleRight() {
    grid = right_gravity(grid);
  }

  function handleKeyPress(event) {
    switch (event.key) {
      case "ArrowUp":
        handleUp();
        break;
      case "ArrowDown":
        handleDown();
        break;
      case "ArrowLeft":
        handleLeft();
        break;
      case "ArrowRight":
        handleRight();
        break;
      default:
        // Not an arrow key
        break;
    }
  }

  onMount(() => {
    window.addEventListener("keydown", handleKeyPress);
  });

  onDestroy(() => {
    window.removeEventListener("keydown", handleKeyPress);
  });
</script>

<div class="flex justify-center items-center h-screen">
  <div class="grid grid-cols-4 gap-2">
    {#each grid as row}
      {#each row as character}
        <div
          class="aspect-w-1 aspect-h-1 w-32 h-32 flex justify-center items-center border border-black"
        >
          {character}
        </div>
      {/each}
    {/each}
  </div>
</div>
