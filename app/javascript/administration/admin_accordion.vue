<template>
  <b-card no-body class="mb-1">
    <b-card-header header-tag="header" class="p-1" role="tab">
      <b-button block v-b-toggle="id" variant="primary" class="text-left">
        <span class="when-closed pr-2"><b-icon-minecart-loaded></b-icon-minecart-loaded></span>
        <span class="when-open pr-2"><b-icon-minecart></b-icon-minecart></span>
        {{title}}
        <span class="float-right when-closed"><b-icon-caret-down-fill></b-icon-caret-down-fill></span>
        <span class="float-right when-open"><b-icon-caret-up-fill></b-icon-caret-up-fill></span>
      </b-button>
    </b-card-header>
    <b-collapse :id="id" accordion="admin-accordion" role="tabpanel">
      <b-card-body>
        <slot></slot>
      </b-card-body>
    </b-collapse>
  </b-card>
</template>

<script>
export default {
  name: "AdminAccordion",
  props: ['title', 'id']
}
</script>

<style lang="scss" scoped>
.collapsed > .when-open,
.not-collapsed > .when-closed {
  display: none;
}

</style>
