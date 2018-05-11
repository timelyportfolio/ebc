<template>
    <el-dialog title="Registration and Acknowledgement" :visible.sync = "dialogVisible" @close="handleClose">
        <el-form :model="form" ref="registerForm">
            <el-form-item
                prop="email"
                label="Email"
                :label-width="formLabelWidth"
                :rules="[
                    { required: true, message: 'Please input email address', trigger: 'blur' },
                    { type: 'email', message: 'Please input correct email address', trigger: 'blur,change' }
                ]"
                ref="emailItem"
            >
                <el-input v-model="form.email" auto-complete="off" @change="checkEmail()"></el-input>
            </el-form-item>
            <el-form-item label="Name" :label-width="formLabelWidth">
                <el-input v-model="form.name" auto-complete="off"></el-input>
            </el-form-item>
            <el-form-item label="Organization" :label-width="formLabelWidth">
                <el-input v-model="form.organization" auto-complete="off"></el-input>
            </el-form-item>
            <el-form-item label="Agreement"
              :rules = "[
                {required: true, trigger: 'change'}
              ]"
              :label-width="formLabelWidth"
            >
              <el-checkbox v-model="form.checked">
                  I agree to appropriately cite the source of the data being downloaded<br/> 
                  if it will be used in any publications.
              </el-checkbox>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
            <el-button @click="dialogVisible = false">Cancel</el-button>
            <el-button type="primary" @click="submit('registerForm')" :disabled="!validForm">Confirm</el-button>
        </span>
    </el-dialog>
</template>

<script>
import axios from "axios";
import { Dialog, Form, FormItem, Input, Button, Checkbox } from "element-ui";

axios.defaults.crossDomain = true;

export default {
  components: {
    "el-dialog": Dialog,
    "el-form": Form,
    "el-form-item": FormItem,
    "el-input": Input,
    "el-button": Button,
    "el-checkbox": Checkbox
  },
  props: ["visible"],
  data: function() {
    return {
      registered: false,
      validEmail: false,
      form: {
        email: "",
        name: "",
        organization: "",
        checked: false
      },
      formLabelWidth: "120px",
      dialogVisible: false
    };
  },
  computed: {
    validForm: function() {
      return this.form.checked && this.validEmail;
    }
  },
  watch: {
    visible: function() {
      this.dialogVisible = this.visible;
    }
  },
  methods: {
    handleClose: function() {
      this.$emit("close");
    },
    checkEmail: function() {
      if (this.$refs.emailItem) {
        this.validEmail = this.$refs.emailItem.validateState === "success";
      } else {
        this.validEmail = false;
      }
    },
    submit: function(formName) {
      var thiz = this;
      if (thiz.validForm) {
        var data = {
          email: thiz.form.email,
          name: thiz.form.name,
          organization: thiz.form.organization
        };

        if (data.name === "") delete data.name;
        if (data.organization === "") delete data.organization;

        axios
          .post(
            "https://b3mhxedpr3.execute-api.us-east-2.amazonaws.com/dev/register",
            data
          )
          .then(function(response) {
            thiz.registered = true;
            thiz.$emit("registerComplete");
            thiz.dialogVisible = false;
          })
          .catch(function(error) {
            //console.log(error);
          });
      } else {
        //console.log('error submit!!');
        return false;
      }
    }
  }
};
</script>
