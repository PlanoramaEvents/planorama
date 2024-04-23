<template>
  <div>
    <h5>{{title}} <edit-button v-b-modal="modalName"></edit-button></h5>
    <slot name="dl" :slot-scope="{fields}">
      <dl-person :fields="fields"></dl-person>
    </slot>
    <person-edit-modal :id="modalName" :person="selected" :data="modalData">
      <template #modal-title>Edytuj {{title}} - {{selected.published_name}}</template>
      <template #default="slotData">
        <template v-for="field, i in fields">
          <b-form-group :key="i" :label="PROFILE_FIELD_LABELS[field]">
            <slot :name="field" :slot-scope="{field: slotData.fields[field]}">
              <b-form-input type="text" v-model="slotData.fields[field]"></b-form-input>
            </slot>
          </b-form-group>
        </template>
      </template>
    </person-edit-modal>
  </div>
</template>

<script>
import DlPerson from './dl_person.vue';
import EditButton from '@/components/edit_button';
import PersonEditModal from './person_edit_modal.vue';
import { modelMixinNoProp } from '@/mixins';
import { personModel as model } from '@/store/person.store';

export default {
  name: "DlPersonWithEdit",
  props: {
    fields: {
      required: true,
      type: Array
    },
    modalName: {
      required: true,
      type: String
    },
    title: {
      required: true,
      type: String
    }
  },
  components: {
    DlPerson,
    EditButton,
    PersonEditModal
  },
  mixins: [
    modelMixinNoProp
  ],
  computed: {
    modalData() {
      return this.fields.reduce((p, c) => ({...p, [c]: null}), {})
    }
  },
  data: () => ({
    model
  })
}
</script>

<style>

</style>
