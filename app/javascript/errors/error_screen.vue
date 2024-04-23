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
        '100': "Wystąpił problem z procesem uwierzytelniania.",
        '101': "Wygląda na to, że tożsamość rejestracyjna, którą próbowałeś użyć, jest już używana przez innego użytkownika Planoramy.",
        '102': "Wygląda na to, że adres e-mail powiązany z tożsamością rejestracyjną, którą próbowałeś użyć, jest już używany przez innego użytkownika Planoramy."
      }
    }
  },
}
</script>

<style>
</style>
