<template>
  <div>
    <button @click="count++">Dodaj</button>
    <p>Liczba kliknięć: {{ count }}</p>
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
