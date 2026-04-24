<template>
  <div class="scrollable">
    <labels-by-area></labels-by-area>
  </div>
</template>

<script>
import LabelsByArea from '@/session-reports/labels-by-area';

export default {
  name: "SessionReportsScreen",
  components: {
    LabelsByArea
  }
}

</script>
