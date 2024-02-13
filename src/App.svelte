<script>
  console.log("loading.");
  import { onMount, onDestroy } from "svelte";
  import Hammer from "hammerjs";

  let grid = null;
  let count = null;
  let modulus = 4;
  let message = null;
  let game_over = null;

  function add(value) {
    let empty_cells = [];
    for (let i = 0; i < grid.length; i++) {
      for (let j = 0; j < grid[i].length; j++) {
        if (grid[i][j] === " ") {
          empty_cells.push([i, j]);
        }
      }
    }
    if (empty_cells.length === 0) {
      return;
    }
    let [i, j] = empty_cells[Math.floor(Math.random() * empty_cells.length)];
    grid[i][j] = value;
  }

  function reset_game() {
    grid = [
      [" ", " ", " ", " "],
      [" ", " ", " ", " "],
      [" ", " ", " ", " "],
      [" ", " ", " ", " "],
    ];
    add("1");
    count = 0;
    message = "Leo is counting to 10. Help him out!";
    game_over = false;
  }

  reset_game();

  // Apply gravity to "move the row to the start".
  // May be destructive.
  // Returns the new row.
  function apply_gravity_to_row(row) {
    let answer = [];
    let pending = null;
    for (let value of row) {
      if (value === " ") {
        continue;
      }
      if (pending === null) {
        pending = value;
      } else if (pending === value) {
        answer.push("" + (+value + 1));
        pending = null;
      } else {
        answer.push(pending);
        pending = value;
      }
    }
    if (pending !== null) {
      answer.push(pending);
    }
    while (answer.length < row.length) {
      answer.push(" ");
    }
    return answer;
  }

  function has(g, value) {
    for (let row of g) {
      for (let cell of row) {
        if (cell === value) {
          return true;
        }
      }
    }
    return false;
  }

  function remove(g, value) {
    return g.map((row) => row.map((cell) => (cell === value ? " " : cell)));
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

  function eq(g1, g2) {
    for (let i = 0; i < g1.length; i++) {
      for (let j = 0; j < g1[i].length; j++) {
        if (g1[i][j] !== g2[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  function is_legal(f) {
    let copy = copy_grid(grid);
    return !eq(f(copy), copy);
  }

  function enact(f) {
    if (game_over) {
      return;
    }
    if (is_legal(f)) {
      grid = f(grid);
      add("1");

      count += 1;
      if (count % modulus === 0) {
        if (has(grid, "Leo")) {
          grid = remove(grid, "Leo");
        } else if (has(grid, " ")) {
          add("Leo");
        }
      }
    }

    if (
      !is_legal(up_gravity) &&
      !is_legal(down_gravity) &&
      !is_legal(left_gravity) &&
      !is_legal(right_gravity)
    ) {
      game_over = true;
      message = "You lose! Play again?";
      return;
    }

    if (has(grid, "10")) {
      game_over = true;
      message = "You win! Play again?";
      return;
    }
  }

  function handle_key_press(event) {
    switch (event.key) {
      case "ArrowUp":
        enact(up_gravity);
        break;
      case "ArrowDown":
        enact(down_gravity);
        break;
      case "ArrowLeft":
        enact(left_gravity);
        break;
      case "ArrowRight":
        enact(right_gravity);
        break;
      default:
        // Not an arrow key
        break;
    }
  }

  function handleClick() {
    if (game_over) {
      reset_game();
    }
  }

  onMount(() => {
    window.addEventListener("keydown", handle_key_press);

    let mc = new Hammer(document.body);

    // @ts-ignore
    mc.get("swipe").set({
      // @ts-ignore
      direction: Hammer.DIRECTION_ALL, // Recognize swipe in all directions
    });

    // Listen for swipe gestures
    // @ts-ignore
    mc.on("swipeup", function (ev) {
      enact(up_gravity);
    });

    // @ts-ignore
    mc.on("swipedown", function (ev) {
      enact(down_gravity);
    });

    // @ts-ignore
    mc.on("swipeleft", function (ev) {
      enact(left_gravity);
    });

    // @ts-ignore
    mc.on("swiperight", function (ev) {
      enact(right_gravity);
    });
  });

  onDestroy(() => {
    window.removeEventListener("keydown", handle_key_press);
  });

  function get_info(str) {
    switch (str) {
      case "Leo":
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9":
      case "10":
        return {
          style: `background-image: url(${str}.png); background-size: cover`,
        };
      default:
        return { text: str };
    }
  }

  function get_style(str) {
    return get_info(str).style || "";
  }

  function get_text(str) {
    return get_info(str).text || " ";
  }
</script>

<div class="centered-container">
  <div class="flex justify-center items-center"></div>
  <div class="flex justify-center items-center">
    <div class="grid grid-cols-4 gap-2">
      {#each grid as row}
        {#each row as str}
          <div
            class="aspect-w-1 aspect-h-1 w-16 h-16 flex justify-center items-center border border-black"
            style={get_style(str)}
          >
            {get_text(str)}
          </div>
        {/each}
      {/each}
    </div>
  </div>

  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <!-- svelte-ignore a11y-no-static-element-interactions -->
  <div
    class="flex justify-center items-center h-32"
    style={game_over ? "cursor: pointer;" : ""}
    on:click={handleClick}
  >
    {message}
  </div>
</div>

<style>
  .centered-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100vh; /* Use 100vh to make the container fill the screen vertically */
  }
</style>
