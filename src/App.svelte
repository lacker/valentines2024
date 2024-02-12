<script>
  import { onMount, onDestroy } from "svelte";

  let grid = [
    ["A", "B", "C", "D"],
    ["E", "F", "G", "H"],
    ["I", "J", "K", "L"],
    ["M", "N", "O", "P"],
  ];

  function shuffle_rows() {
    grid = grid.map((row) => row.sort(() => Math.random() - 0.5));
  }

  function handleUp() {
    console.log("up");
  }

  function handleDown() {
    console.log("down");
  }

  function handleLeft() {
    console.log("left");
  }

  function handleRight() {
    console.log("right");
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
