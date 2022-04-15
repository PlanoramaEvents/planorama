<template>
  <validation-observer slim ref="socialObserver">
    <validation-provider
      mode="aggressive"
      :rules="rules"
      :name="label"
      :skipIfEmpty="true"
      v-slot="{ valid, errors }"
    >
      <simple-social
        :label="label"
        :prepend="prepend"
        v-model="editable_val"
        @blur="onChange"
        :state="calcValid(errors,valid)"
        :disabled="disabled"
      >
      </simple-social>
      <div class="invalid-message" v-if="errors[0] && message">{{ message }}</div>
      <div class="invalid-message" v-if="errors[0] && !message">{{ errors[0] }}</div>
    </validation-provider>
  </validation-observer>
</template>

<script>
import { ValidationProvider, ValidationObserver} from 'vee-validate';
import SimpleSocial from '../social-media/simple-social.vue';

export default {
  name: 'ValidatedSocial',
  components: {
    ValidationProvider,
    ValidationObserver,
    SimpleSocial
  },
  props: {
    label: {
      type: String,
      required: true
    },
    message: {
      type: String,
      required: false
    },
    prepend: {
      type: String,
      required: true
    },
    rules: {
      type: Object,
      required: true
    },
    value: null,
    disabled: false
  },
  data: () =>  ({
    editable_val: null
  }),
  methods: {
    calcValid(errors, valid) {
      if (this.rules == '') {
        return null
      }

      return errors[0] ? false : null //(valid ? true : null)
    },
    onChange(arg) {
      // if (this.value == '') return;
      this.$refs["socialObserver"].validate().then(
        (result) => {
          if (result) {
            this.$emit('input', arg)
          }
        }
      )
    }
  },
  mounted() {
    this.editable_val = this.value
  }
}
</script>

<style lang="scss">
.invalid-message {
  width: 100%;
  margin-top: .25rem;
  font-size: .875em;
  color: #dc3545;
}
</style>
