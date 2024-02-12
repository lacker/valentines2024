<script>
  let grid = [
    ["A", "B", "C", "D"],
    ["E", "F", "G", "H"],
    ["I", "J", "K", "L"],
    ["M", "N", "O", "P"],
  ];
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
