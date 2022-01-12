/*
 * Copyright (c) 2021 fuxiaohei. All rights reserved.
 * Licensed under the Apache-2.0 License. See License file in the project root for
 * license information.
 */

#pragma once

#include <common/heap.h>
#include <hv/HttpServer.h>
#include <webapi/fetch/fetch_event.h>

namespace core {

class RequestScope {
 public:
  webapi::FetchEvent* create_fetch_event();

  void set_error_msg(int errcode, const std::string& msg, const std::string& stack = "");
  bool is_error() const { return error_code_ != 0; }

  int handle_response();

  void destroy();

 public:
  common::Heap* heap_ = nullptr;

 private:
  friend class Worker;
  explicit RequestScope(const HttpContextPtr& ctx);
  ~RequestScope();

 private:
  std::string error_response_body();

 private:
  HttpContextPtr ctx_;

  int error_code_ = 0;
  std::string error_msg_;
  std::string error_stack;

  int response_status_code_ = HTTP_STATUS_OK;
  std::atomic<bool> is_response_sent_;
};

}  // namespace core
