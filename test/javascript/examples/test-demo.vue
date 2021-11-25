<template>
  <div>
    <button @click="count++">Add up</button>
    <p>Total clicks: {{ count }}</p>
  </div>
</template>

<script>
export default {
  name: "TestCounter",
  data: () => ({
    count: 0
  })
}
</script>

<style>

</style>
