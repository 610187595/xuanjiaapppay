/*
 Copyright 2015 Baidu Inc. All rights reserved.
 File Name:   BDWalletJavascript.js
 Author:      Baidu
 Data:        2015-1-30
 Description: Javascript Library Of Baidu Wallet App
 Modification:
 1. 轻应用注入JS脚本
 */


;(function() {
  var require, define;
  
  (function() {
   var modules = {},
   // Stack of moduleIds currently being built.
   requireStack = [],
   // Map of module ID -> index into requireStack of modules currently being built.
   inProgressModules = {},
   SEPERATOR = ".";
   
   function build(module) {
   var factory = module.factory,
   localRequire = function (id) {
   var resultantId = id;
   //Its a relative path, so lop off the last portion and add the id (minus "./")
   if (id.charAt(0) === ".") {
   resultantId = module.id.slice(0, module.id.lastIndexOf(SEPERATOR)) + SEPERATOR + id.slice(2);
   }
   return require(resultantId);
   };
   
   module.exports = {};
   delete module.factory;
   factory(localRequire, module.exports, module);
   return module.exports;
   }
   
   require = function (id) {
   if (!modules[id]) {
   throw "module " + id + " not found";
   } else if (id in inProgressModules) {
   var cycle = requireStack.slice(inProgressModules[id]).join('->') + '->' + id;
   throw "Cycle in require graph: " + cycle;
   }
   
   if (modules[id].factory) {
   try {
   inProgressModules[id] = requireStack.length;
   requireStack.push(id);
   return build(modules[id]);
   } finally {
   delete inProgressModules[id];
   requireStack.pop();
   }
   }
   
   return modules[id].exports;
   };
   
   define = function (id, factory) {
   if (modules[id]) {
   throw "module " + id + " already defined";
   }
   
   modules[id] = {
   id: id,
   factory: factory
   };
   };
   
   define.remove = function (id) {
   delete modules[id];
   };
   
   define.moduleMap = modules;
   })();
  
  define("bba_la_node", function(require, exports, module) {
         
         var bbaLANode = {
         callbackId: Math.floor(Math.random() * 2000000000),
         callbacks: {},
         commandQueue: [],
         groupId: Math.floor(Math.random() * 300),
         groups: {},
         listeners: {},
         
         invoke: function(cmd, params, onSuccess, onFail, tailParams) {
         if(!cmd) cmd = "defaultCommand";
         if(!params) params = {};
         this.callbackId ++;
         this.callbacks[this.callbackId] = {
         success: onSuccess,
         fail: onFail
         };
         var rurl = "baiduwallet://" + cmd + tailParams + "/" + JSON.stringify(params);
         document.location = rurl;
         },
         callbackSuccess: function(callbackId, params) {
         try {
         bbaLANode.callbackFromNative(callbackId, params, true);
         } catch (e) {
         console.log("Error in error callback: " + callbackId + " = " + e);
         }
         },
         callbackError: function(callbackId, params) {
         try {
         bbaLANode.callbackFromNative(callbackId, params, false);
         } catch (e) {
         console.log("Error in error callback: " + callbackId + " = " + e);
         }
         },
         callbackFromNative: function(callbackId, params, isSuccess) {
         var callback = this.callbacks[callbackId];
         if (callback) {
         if (isSuccess) {
         callback.success && callback.success(callbackId, params);
         } else {
         callback.fail && callback.fail(callbackId, params);
         }
         delete bbaLANode.callbacks[callbackId];
         };
         },
         };
         
         module.exports = bbaLANode;
         });
  
  window.bba_la_node = require("bba_la_node");
  
  }) ();

// ================== Light App Node Invoke ==================


window.BLightApp = window.BLightApp ? window.BLightApp : {};

/* -- 支付端能力 -- */
BLightApp.dopay = function(sucessFn, failFn, orderInfo, hideLoadingDialog, options)
{
    sucessFn = encodeURIComponent(encodeURIComponent(sucessFn || ''));
    failFn = encodeURIComponent(encodeURIComponent(failFn || ''));
    options = encodeURIComponent(encodeURIComponent(options || ''));
    orderInfo = orderInfo || '';
    hideLoadingDialog = encodeURIComponent(encodeURIComponent(hideLoadingDialog || ''));
    var params = {'successcallback' : sucessFn, 'hideloadingdialog' : hideLoadingDialog, 'errorcallback' : failFn, 'options' : options};
    var onSuccess = function (callbackId, params) {
    };
    var onFail = function (callbackId, params) {
    };
    
    var scheme = 'doPay?';
    window.bba_la_node.invoke(scheme, params, onSuccess, onFail, orderInfo);
};

/* -- 登录端能力 -- */
BLightApp.bdLogin = function(options, sucessFn, failFn)
{
    sucessFn = encodeURIComponent(encodeURIComponent(sucessFn || ''));
    failFn = encodeURIComponent(encodeURIComponent(failFn || ''));
    options = encodeURIComponent(encodeURIComponent(options || ''));
    
    var params = {'successcallback' : sucessFn, 'errorcallback' : failFn, 'options' : options, 'action' : 'lalogindialog'};
    var onSuccess = function (callbackId, params) {
    };
    var onFail = function (callbackId, params) {
    };
    window.bba_la_node.invoke('bdLogin?', params, onSuccess, onFail, '');
};

/* -- 分享端能力 -- */
BLightApp.callShare = function(options, sucessFn, failFn)
{
    sucessFn = encodeURIComponent(encodeURIComponent(sucessFn || ''));
    failFn = encodeURIComponent(encodeURIComponent(failFn || ''));
    options = encodeURIComponent(encodeURIComponent(options || ''));
    
    var params = {'successcallback' : sucessFn, 'errorcallback' : failFn, 'options' : options};
    var onSuccess = function (callbackId, params) {
    };
    var onFail = function (callbackId, params) {
    };
    window.bba_la_node.invoke('callShare?', params, onSuccess, onFail, '');
};

/* -- 地理位置能力 -- */
BLightApp.getCurrentPosition = function(options, sucessFn, failFn)
{
    sucessFn = encodeURIComponent(encodeURIComponent(sucessFn || ''));
    failFn = encodeURIComponent(encodeURIComponent(failFn || ''));
    options = encodeURIComponent(encodeURIComponent(options || ''));
    
    var params = {'successcallback' : sucessFn, 'errorcallback' : failFn, 'options' : options};
    var onSuccess = function (callbackId, params) {
    };
    var onFail = function (callbackId, params) {
    };
    window.bba_la_node.invoke('getCurrentLocation?', params, onSuccess, onFail, '');
};

/* -- Runtime注入成功 -- */
function kuangRuntimeReady()
{
    var event = document.createEvent('Events');
    event.initEvent('runtimeready', false,false);
    document.dispatchEvent(event);
}

kuangRuntimeReady();

// Check
function CheckJSLib()
{
    return "ok";
}

CheckJSLib();