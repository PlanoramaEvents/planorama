<template>
  <div>
    <div v-if="regData">
      <slot name="heading"></slot>
      <div>Full Name: {{ regData.name }}</div>
      <div>Email: {{ regData.email }}</div>
      <div class="mb-2">Registration ID: {{ regData.registration_number }}</div>
      <div>Preferred Name: {{ regData.preferred_name }}</div>
      <div>Badge Name: {{ regData.badge_name }}</div>
      <div>Alternate Email: {{  regData.alternative_email }}</div>
      <div>Product: {{ regData.raw_info.product }}</div>
      <div>Attending Status: {{ regData.raw_info.attending_status }}</div>
    </div>
    <slot name="empty" v-if="!regData"></slot>
  </div>
</template>

<script>
export default {
  name: "DisplaySyncData",
  props: {
    regData: {
      required: true
    }
  }
}
</script>

<style>

</style>
