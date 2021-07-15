<template>
  <div>
    <div class="float-left pr-1">{{i}}.</div>
    <div class="ml-4">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: "DropdownItem",
  props: ['i', 'disabled']
}
</script>
