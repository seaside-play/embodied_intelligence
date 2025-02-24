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
#ifndef JDF_IO_STATE_H
#define JDF_IO_STATE_H

namespace jdf {

class IOState {
private:
    IOState() = default;
    IOState(const IOState&) = delete;
    IOState& operator=(const IOState&) = delete;

public:
    /**
    * @brief 获取本次ARCS中京东方IO是否生效的全局唯一句柄对象
    *
    * @return IOState&：返回唯一句柄对象
    */
    static IOState& GetInstance();

    /**
    * @brief 获取io是否生效
    *
    * @return bool true-表示生效 false-表示未生效
    */
    bool io_in_effect() { return m_io_in_effect; }

    /**
    * @brief 设置本次io是否生效状态
    *
    * @param io_state true-表示生效 false-表示未生效
    */
    void io_in_effect(bool io_state) { m_io_in_effect = io_state; }

private:
    bool m_io_in_effect {false};

}; // class IOState

} // namespace jdf

#endif // JDF_IO_STATE_H