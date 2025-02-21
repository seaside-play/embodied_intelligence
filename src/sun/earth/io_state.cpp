/***************************************************************************
 tag: verdant  2024-12-12  io_state.hpp

 io_state.hpp -  description
 -------------------
 author               : Chaojiang Wu
 begin                : 2024-12-12
 copyright            : Copyright(C) 2024 Peitian. All Rights Reserved.
 email                : chaojiang.wu@peitiana.com
 ***************************************************************************
 *                                                                         *
 *Information in this file is the intellectual property of Peitian, and may*
 *contains trade secrets that must be stored and viewed confidentially.    *
 *                                                                         *
 **************************************************************************/
/**************************************************************************
 *                                                                         *
 *@brief 提供京东方IO生效状态
 *                                                                         *
 ***************************************************************************/
#include "io_state.hpp"

namespace jdf {

/**
* @brief 获取本次ARCS中京东方IO是否生效的全局唯一句柄对象
*
* @return IOState&：返回唯一句柄对象
*/
IOState& IOState::GetInstance() {
    static IOState io_state;
    return io_state;
}

} // namespace jdf