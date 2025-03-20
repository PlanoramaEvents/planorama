<template>
  <div>
    <edit-modal
      v-bind="$attrs"
      :id="id"
      :title="title"
      @cancel="$emit('cancel', $event)"
      @close="$emit('close', $event)"
      @ok="confirm"
      ok-title="Confirm"
      no-stacking
    >
      <slot v-for="(_, name) in modalSlots" :name="name" />
      <template v-for="(_, name) in modalScopedSlots" v-slot:[name]="slotData">
        <slot :name="name" v-bind="slotData"></slot>
      </template>
    </edit-modal>
    <edit-modal
      v-on="$listeners"
      :id="confirmId"
      @cancel="$emit('cancel', $event)"
      @close="$emit('close', $event)"
      :title="confirmTitle"
    >
      <slot v-for="(_, name) in confirmSlots" :name="`confirm-${name}`" />
      <template v-for="(_, name) in confirmScopedSlots" v-slot:[name]="slotData">
        <slot :name="`confirm-${name}`" v-bind="slotData"></slot>
      </template>
    </edit-modal>
  </div>
</template>

<script>
import EditModal from './edit_modal';

export default {
  name: "BulkEditModal",
  props: {
    id: {
      type: String,
      default: 'bulk-edit'
    },
    title: {
      type: String,
      default: "Bulk Edit"
    }
  },
  components: {
    EditModal
  },
  computed: {
    confirmId() {
      return `${this.id}-confirm`
    },
    confirmTitle() {
      return `${this.title} Confirmation`
    },
    modalSlots() {
      return Object.fromEntries(Object.entries(this.$slots).filter(([name, _]) => !name.startsWith('confirm')))
    },
    confirmSlots() {
      return Object.fromEntries(Object.entries(this.$slots).filter(([name, _]) => name.startsWith('confirm')).map(([name, val]) => [name.replace(/confirm-/, ''), val]))
    },
    modalScopedSlots() {
      return Object.fromEntries(Object.entries(this.$scopedSlots).filter(([name, _]) => !name.startsWith('confirm')))
    },
    confirmScopedSlots() {
      return Object.fromEntries(Object.entries(this.$scopedSlots).filter(([name, _]) => name.startsWith('confirm')).map(([name, val]) => [name.replace(/confirm-/,''), val]))
    }
  },
  methods: {
    confirm() {
      this.$bvModal.show(this.confirmId)
    }
  }
}
</script>

<style>

</style>
