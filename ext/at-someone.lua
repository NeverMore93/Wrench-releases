#!/usr/bin/env Wrench
-- 在QQ、微信等聊天时想@一下某人

local old_top_widow = adb_top_window()
local top_window
wrench_post("@", 'manual-post')
for i = 1, 10 do
   top_window = adb_top_window()
   if top_window and top_window ~= "" and top_window ~= old_top_widow then
      break
   end
   sleep(.1)
end


search = select_args_with_history("at-someone", "你想@谁？", " ", "")

local wait_for_input = false
if top_window == "com.tencent.mm/com.tencent.mm.ui.chatting.AtSomeoneUI" then
   tap_top_right()
   wait_for_input = 'weixin'
end

if top_window == "com.tencent.mobileqq/com.tencent.mobileqq.activity.TroopMemberListActivity" then
   if real_height == 2160 then
      adb_event"adb-tap 384 211"
   else
      adb_event"adb-tap 489 288"
   end
   wait_for_input = 'qq'
end

if wait_for_input then
   if not wait_input_target_n_ok(5, top_window) then
      prompt_user("无法等到搜索@某人的搜索框输入")
      return
   end
else
   prompt_user("请确认已经在你可以输入 %s 的输入窗口", search)
end

wrench_post(search, 'manual-post')

if wait_for_input and yes_or_no_p("请确认你用 %s 搜出来的第一个联系人，是否就是你想@的那个\n\n如是，确认后自动为你点击；如不是，请取消并手动点击想@的联系人", search) then
   if wait_for_input == 'qq' then
      adb_event("adb-tap 502 272")
      adb_event"adb-tap 500 226"
   elseif wait_for_input == 'weixin' then
      adb_event("adb-tap 382 298")
   end
end

