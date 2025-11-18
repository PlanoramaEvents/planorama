<template>
  <div class="d-inline" :title="NOT_IMPLEMENTED">
    <slot></slot>
  </div>
</template>

<script>
import {NOT_IMPLEMENTED} from '../constants/strings'

export default {
  name: "NotImplemented",
  data: () => ({
    NOT_IMPLEMENTED
  })
}
</script>
