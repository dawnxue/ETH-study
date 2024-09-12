// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsertionSort {

    // 定义一个函数，用于接收用户输入的数组并对其进行排序
    function sortArray(uint[] memory arr) public pure returns (uint[] memory) {
        // 获取数组的长度
        uint n = arr.length;

        // 执行插入排序算法
        for (uint i = 1; i < n; i++) {
            uint key = arr[i];
            uint j = i;

            // 将key与已排序部分的数组进行比较并插入到正确位置
            while (j > 0 && arr[j - 1] > key) {
                arr[j] = arr[j - 1];
                j--;
            }
            arr[j] = key;
        }

        // 返回排序后的数组
        return arr;
    }
}
