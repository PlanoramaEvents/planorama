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
        @blur="onBlur"
        :value="value"
        :disabled="disabled"
        :state="state"
      ></b-form-input>
    </b-input-group>
  </b-form-group>
</template>

<script>
export default {
  name: "SimpleSocial",
  props: {
    state: {
      type: Boolean,
      default: true
    },
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
      required: false
    }
  },
  computed: {
    groupId() {
      return `${this.id}-group`;
    }
  },
  methods: {
    onBlur(e) {
      this.$emit('input', e.target.value)
      this.$emit('blur', e.target.value)
    }
  }
}
</script>

<style>

</style>
