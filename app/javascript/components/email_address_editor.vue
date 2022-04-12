<template>
  <div class="d-flex flex-row w-100">
    <validation-observer slim ref="emailObserver">
      <ValidationProvider
        mode="aggressive"
        rules="email"
        name="Email"
        :skipIfEmpty="true"
        v-slot="{ valid, errors }"
        class="w-75 mt-2 mr-3"
      >
        <b-form-input
          :disabled='disabled'
          :state="calcValid(errors,valid)"
          v-model="value.email"
          @change="onChange"
        ></b-form-input>
        <b-form-invalid-feedback>{{ errors[0] }}</b-form-invalid-feedback>
      </ValidationProvider>
    </validation-observer>
    <!-- {{ value.isdefault }} -->
    <div class="w-25">
      <div class="d-flex flex-row w-100">
        <b-form-radio
          switch size="lg"
          value="true"
          @change="onCheck"
          :checked="isdefault"
          class="mt-2 pt-1"
          :disabled='disabled'
        >
        </b-form-radio>
        <b-button v-if="canDelete" @click="onDelete" size="sm" title="Delete" class="mt-2" variant="primary">
          <b-icon-trash></b-icon-trash>
        </b-button>
      </div>
    </div>
  </div>
</template>

<script>
import { ValidationProvider, ValidationObserver} from 'vee-validate';

export default {
  name: 'EmailAddressEditor',
  components: {
    ValidationProvider,
    ValidationObserver
  },
  props: {
    value: null,
    canDelete: {
      type: Boolean,
      default: true
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data: () =>  ({
    val: null
  }),
  computed: {
    isdefault: {
      get: function() {
        if (this.value.isdefault) {
          return this.value.isdefault
        } else {
          return null
        }
      },
      set: function(val) {
        // Vue complains if there is no set
        // but we are not setting the isDefault here anyway
        // it is an artifact of using radio buttons in a "fake" group
        // and relying on server side sync to set things
      }
    }
  },
  methods: {
    onCheck(arg) {
      this.value.isdefault = arg == 'true'
      this.emitChange()
    },
    onDelete(arg) {
      this.$emit('delete', this.value)
    },
    calcValid(errors, valid) {
      if (this.rules == '') {
        return null
      }
      let v = errors[0] ? false : null //(valid ? true : null);
      this.is_valid = v
      return v;
    },
    onChange(arg) {
      this.emitChange()
    },
    emitChange() {
      if (this.value.email == '') return;

      this.$refs["emailObserver"].validate().then(
        (result) => {
          if (result) {
            this.$emit('input', this.value)
          }
        }
      )
    }
  }
}
</script>
