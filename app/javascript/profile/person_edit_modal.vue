<template>
  <v-form as="div" ref="personEditForm" v-slot="{ handleSubmit, errors, meta }">
    <edit-modal
      @show="mirrorFromPerson()"
      @ok="(event) => { handleSubmit(event, patchPerson); }"
      :ok-disabled="validate ? meta.dirty && !meta.valid : false"
      v-bind="$attrs"
      v-on="$listeners"
    >
      <slot v-for="(_, name) in $slots" :name="name" />
      <template v-for="(_, name) in $slots" v-slot:[name]="slotData">
        <slot :name="name" v-bind="{ ...slotData, fields: data }" />
      </template>
    </edit-modal>
  </v-form>
</template>

<script>
import EditModal from '@/components/edit_modal'
import { PATCH_PERSON_MODEL } from '@/store/person.store';
import { mapActions } from 'vuex';
import toastMixin from '@/shared/toast-mixin';
import { FETCH_BY_ID } from '@/store/model.store';
import { PERSON_SAVE_SUCCESS } from '@/constants/strings';
import { Form as VForm } from 'vee-validate';

export default {
  name: "PersonEditModal",
  components: {
    EditModal,
    VForm
  },
  mixins: [
    toastMixin
  ],
  props: {
    person: {
      required: true,
    },
    data: {
      required: true
    },
    validate: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    ...mapActions({
      patchPersonModel: PATCH_PERSON_MODEL,
      fetchById: FETCH_BY_ID
    }),
    mirrorFromPerson() {
      Object.keys(this.data).map(k => {
        this.data[k] = this.person?.[k];
      })
    },
    patchPerson() {
      this.toastPromise(this.patchPersonModel({person: this.person, data: this.data}), PERSON_SAVE_SUCCESS).then((savedPerson) => {
        this.$emit('updated', savedPerson);
      })
    }
  }
}
</script>

<style>

</style>
