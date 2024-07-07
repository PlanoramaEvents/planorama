<template>
  <b-card no-body class="mb-1">
    <b-card-header header-tag="header" class="p-1 schedule-title" role="tab">
      <div class="d-flex justify-content-between align-items-center">
      <b-button block v-b-toggle="id" variant="none" squared class="text-left">
        <div class="d-flex justify-content-between align-items-center">
        <span><slot name="title">{{title}}</slot>
        <span v-if="dirty" class="pl-2" v-b-tooltip title="Unsaved changes"><b-icon-exclamation-circle-fill variant="warning"></b-icon-exclamation-circle-fill></span></span>
        <span class="float-right when-closed ml-2"><b-icon-plus scale="2"></b-icon-plus></span>
        <span class="float-right when-open ml-2"><b-icon-dash scale="2"></b-icon-dash></span>
        </div>
      </b-button>
      <div class="pipe-border" v-if="showJoinLinks">
        <a :href="joinLink" target="_blank" v-if="joinLink" class="larger-text">Join</a>
      </div>
    </div>
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
    joinLink: {
      type: String
    },
    showJoinLinks: {
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
.collapsed .when-open,
.not-collapsed .when-closed {
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

.pipe-border {
  padding: 0.5rem 0.75rem;
  border-left: 2px solid gray;
  min-height: 2.5rem;
  min-width: 5rem;
  flex-basis: 5rem;
  flex-shrink: 0;
  flex-grow: 0;
  font-weight: 700;
}

.larger-text {
  font-size: 16px;
}
</style>
