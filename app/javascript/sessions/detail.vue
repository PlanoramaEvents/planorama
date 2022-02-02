<template>
  <div class="detail">
    <div class="row">
      <div class="col-12">

        <b-button @click="edit" :disabled="editable">Edit</b-button>
        <b-button @click="save" :disabled="!editable">Save</b-button>
        <h2>Basic Information</h2>
        <b-form-group
          label="Title"
        >
          <b-form-input v-model="selected.title" :disabled="!editable"></b-form-input>
        </b-form-group>

        <b-form-group
          label="Description"
        >
          <b-form-textarea
            id="description-text"
            v-model="selected.description"
            :disabled="!editable"
          >
            {{selected.description}}
          </b-form-textarea>
        </b-form-group>

        <b-form-checkbox v-model="selected.open_for_interest" :disabled="!editable">
          Open for Interest
        </b-form-checkbox>

        <b-form-group
          label="Tags"
        >
          <model-tags
            :taggable="true"
            v-model="selected.tag_list"
            model="tag"
            field="name"
            fieldOnly=true
            filter='{"op":"all","queries":[["taggings.taggable_type", "=", "Session"]]}'
            :disabled="!editable"
          ></model-tags>
        </b-form-group>

        <b-form-group
          label="Areas"
        >
          <model-select
            v-model="session_areas"
            model="area"
            field="name"
            :multiple="true"
            :disabled="!editable"
          ></model-select>
        </b-form-group>

        <!--
          Format - selector
        -->
      </div>
    </div>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import ModelSelect from '../components/model_select';
import ModelTags from '../components/model_tags';

export default {
  name: "Detail",
  components: {
    ModelSelect,
    ModelTags
  },
  mixins: [
    modelMixin
  ],
  data: () => ({
    editable: false,
  }),
  computed: {
    session_areas: {
      get() {
        let res = Object.values(this.selected.session_areas).filter(
          obj => (typeof obj.json === 'undefined')
        ).map(
          obj => (
              obj.area_id
          )
        )

        return res // '3cda1cfd-2876-4957-bc9f-f4fcbba578c2' //Object.values(res)
      },
      set(val) {
        let existingAreas = Object.values(this.selected.session_areas)
        let newAreas = val;
        let areasForSaving = [];
        for (let area of newAreas) {
          let existing = existingAreas.find(r => r.area === area);
          if(existing) {
            areasForSaving.push(this.buildArea(existing));
          } else {
            areasForSaving.push({area_id: area})
          }
        }
        for (let area of existingAreas) {
          if(!newAreas.includes(area.area)) {
            areasForSaving.push({...this.buildArea(area), _destroy: 1})
          }
        }

        this.selected.session_areas_attributes = areasForSaving
      }
    }
  },
  methods: {
    edit() {
      this.editable = true
    },
    buildArea(v) {
      return {
        id: v.id,
        area_id: v.area
      }
    },
    save() {
      this.editable = false
      this.saveSelected();
    }
  }
}
</script>

<style>

</style>
