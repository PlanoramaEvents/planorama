<template>
  <div class="tag-display">
    <p>{{ label  }} <edit-button v-b-modal:[modalId]></edit-button></p>
    <span :class="clazz" v-for="tag in value" :key="tag">{{tagFormatter(tag)}}</span>
    <span v-if="!value.length" class="text-muted font-italic">{{ SESSION_NO_TAGS(label) }}</span>
    <edit-modal :id="modalId" :title="modalTitle" @ok="$emit('input', mutableValue)" @hide="clearValue()">
        <b-form-select
        v-model="mutableValue"
        :options="modalOptions"
        :multiple="true"
        size="4"
      ></b-form-select>
    </edit-modal>
  </div>
</template>

<script>
import EditButton from '@/components/edit_button.vue';
import EditModal from '@/components/edit_modal.vue';
import { SESSION_NO_TAGS } from '@/constants/strings';
import { tagsMixin } from '@/store/tags.mixin';

export default {
  name: "TagDisplay",
  props: {
    color: {
      type: String,
      required: true
    },
    label: {
      type: String,
      required: true
    },
    value: {
      default: () => []
    },
    modalOptions: {
      required: true,
    }
  },
  components: {
    EditButton,
    EditModal,
  },
  mixins: [
    tagsMixin,
  ],
  data: () => ({
    imutableValue: [],
    SESSION_NO_TAGS,
  }),
  computed: {
    clazz() {
      return `badge badge-pill mr-1 badge-${this.color} mr-1`
    },
    modalId() {
      return `tag-modal-${this.label.replace(' ', '-')}`
    },
    modalTitle() {
      return `Edit ${this.label}`
    },
    mutableValue: {
      get() {
        return this.imutableValue;
      },
      set(val) {
        this.imutableValue = val;
      }
    }
  },
  methods: {
    clearValue() {
      this.imutableValue = []
    }
  },
  mounted() {
    // Initialize here works better that trying to do something in get
    this.imutableValue = this.value
  }
}
</script>

<style>

</style>
