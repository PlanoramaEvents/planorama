<template>
  <div class="d-flex flex-row">
    <validation-observer slim ref="emailObserver">
      <ValidationProvider
        mode="aggressive"
        rules="email"
        name="Email"
        :skipIfEmpty="true"
        v-slot="{ valid, errors }"
        class="w-25 mt-2 mr-2"
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
    <b-form-radio
      switch size="lg"
      value="true"
      @change="onCheck"
      :checked="isdefault"
      class="mt-2 pt-1"
    >
    </b-form-radio>
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
        // console.debug("****** SET", val)
        // this.value.isdefault
      }
    }
  },
  methods: {
    onCheck(arg) {
      this.value.isdefault = arg == 'true'
      this.emitChange()
    },
    calcValid(errors, valid) {
      if (this.rules == '') {
        return null
      }
      let v = errors[0] ? false : (valid ? true : null);
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
