<template>
  <b-form-group
    :label="label"
    :label-for="id"
    :id="groupId"
    class="mt-2"
  >
    <b-input-group>
      <template #prepend v-if="prepend || $slots.prepend">
        <slot name="prepend">
          <b-input-group-text>{{prepend}}</b-input-group-text>
        </slot>
      </template>
      <b-form-input
        type="text"
        @input="$emit('input', $event)"
        :value="value"
        :disabled="disabled"
      ></b-form-input>
    </b-input-group>
  </b-form-group>
</template>

<script>
export default {
  name: "SimpleSocial",
  props: {
    disabled: {
      type: Boolean,
      default: false
    },
    label: {
      type: String,
      required: true
    },
    prepend: {
      type: String,
      default: null
    },
    value: {
      required: true
    },
    id: {
      type: String,
      required: true
    }
  },
  computed: {
    groupId() {
      return `${this.id}-group`;
    }
  }
}
</script>

<style>

</style>
