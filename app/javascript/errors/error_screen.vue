<template>
  <div>
    <!-- TODO: @gail - UI look and perhaps link back to dashboad/login i.e. "/" -->
    <div class="container mb-3">
      <div class="py-2">
        {{ messages[code] }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "ErrorScreen",
  props: ['code'],
  data() {
    return {
      messages : {
        '100': "There was a problem with the Authentication process.",
        '101': "It appears that the Registration Identity you tried to use is already used by another Planorama user.",
        '102': "It appears that the email associated wiht Registration Identity you tried to use is already used by another Planorama user."
      }
    }
  },
}
</script>

<style>
</style>
