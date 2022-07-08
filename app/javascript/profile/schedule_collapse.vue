<template>
  <b-card no-body class="mb-1">
    <b-card-header header-tag="header" class="p-1 schedule-title" role="tab">
      <b-button block v-b-toggle="id" variant="none" squared class="text-left">
        <!-- <span class="when-closed pr-2"><b-icon-plus scale="2"></b-icon-plus></span>
        <span class="when-open pr-2"><b-icon-dash scale="2"></b-icon-dash></span> -->
        <slot name="title">{{title}}</slot>
        <span v-if="dirty" class="pl-2" v-b-tooltip title="Unsaved changes"><b-icon-exclamation-circle-fill variant="warning"></b-icon-exclamation-circle-fill></span>
        <span class="float-right when-closed"><b-icon-plus scale="2"></b-icon-plus></span>
        <span class="float-right when-open"><b-icon-dash scale="2"></b-icon-dash></span>
      </b-button>
    </b-card-header>
    <b-collapse :id="id" role="tabpanel" @show="show" :value="value" @input="$emit('input', $event)">
      <b-card-body>
        <slot></slot>
      </b-card-body>
    </b-collapse>
  </b-card>
</template>

<script>
export default {
  name: "ScheduleCollapse",
  props: {
    title: {
      type: String
    },
    id: {
      type: String,
      required: true
    },
    dirty: {
      type: Boolean,
      default: false
    },
    value: null
  },
  methods: {
    show(ev) {
      this.$emit('show', ev)
    }
  }
}
</script>

<style lang="scss" scoped>
.collapsed > .when-open,
.not-collapsed > .when-closed {
  display: none;
}

.schedule-title {
  background-color: #ffffff;
  border: 0 0 1px 0;
  border-color: #666666;
}

.card {
  border: 0;
}
</style>
