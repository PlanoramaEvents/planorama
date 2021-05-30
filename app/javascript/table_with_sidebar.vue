<template>
  <div>
    <table-component
      :modelType="modelType"
      :select-event="selectEvent"
      :sort-field="sortField"
      :columns="columns"
      :collection="collection"
    >
    </table-component>
    <sidebar-component :select-event="selectEvent">
      <template v-slot:header>
        <slot name="sidebar-header"
              v-bind:selected="selected"
              v-bind:editable="editable"
              :save="onSave"
              :edit="onEdit"
        >
        </slot>
      </template>
      <template v-slot:content>
        <slot name="sidebar-content"
              v-bind:selected="selected"
              v-bind:editable="editable"
              :save="onSave"
              :edit="onEdit"
        >
        </slot>
      </template>
    </sidebar-component>
  </div>
</template>

<script>
import { EventBus } from './event-bus';
import TableComponent from './table.vue'
import SidebarComponent from './sidebar.vue'

export default {
  name: 'TableWithSidebarComponent',
  components: {
    TableComponent,
    SidebarComponent
  },
  props: {
    modelType : { type: Function },
    collection : { type: Object },
    columns : { type: Array },
    sortField : { type: String },
    selectEvent : { type: String },
    saveEvent : { type: String },
    perPage : { type: Number, default: 15 }
  },
  data() {
    return {
      selected: null,
      editable: false
    }
  },
  methods: {
    onSave() {
      if (this.saveEvent) {
        EventBus.emit(this.saveEvent, this.selected)
      }
      this.editable = false
    },
    onEdit() {
      this.editable = true
    },
    setSelected(v) {
      this.selected = v
      if (v) {
        this.visible = true
      } else {
        this.visible = false
      }
    }
  },
  mounted() {
    if (this.selectEvent) {
      EventBus.on(this.selectEvent, this.setSelected);
    }
  }
}
</script>
