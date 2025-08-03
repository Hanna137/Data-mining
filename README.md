Mục tiêu: 
Xử lý dữ liệu dòng chảy lịch sử, tính toán các thống kê và xu hướng, và đánh giá ảnh hưởng của hiện tượng El Niño đến dòng chảy thông qua mô hình hồi quy và trực quan hóa.


Các tệp tin:
- TH2_Input_22166022.xlsx – Dữ liệu dòng chảy thô của một trạm quan trắc tại Thái Lan, mỗi sheet tương ứng với một năm.
- TH2_Output_22166022.xlsx: chuyển input từ bảng ngang sang dạng bảng dọc , lưu lượng dòng chảy theo ngày.
- avg.xlsx: kết quả tính trung bình dòng chảy tháng của các năm
- stats.xlsx: bảng thống kê mô tả cơ bản cho các tháng 
- nino34.long.anom.data.xlsx – Dữ liệu chỉ số NINO 3.4 (El Niño).
- code.R: tất cả code của bài.

KẾT QUẢ 
Dựa trên biểu đồ hồi quy giữa Month_Avg_Flow và Năm, ta nhận thấy:
- Xu hướng tổng thể của dòng chảy trung bình tháng giảm nhẹ từ 1922-2018, thể hiện qua đường hồi quy màu đỏ có hệ số dốc âm.
- Sự phân tán dữ liệu rất lớn, đặc biệt là những năm có lưu lượng cao đột biến, cho thấy biến thiên mạnh theo năm.
- Khoảng trắng ở giữa biểu đồ là do thiếu dữ liệu của các năm từ 1954-1962, có nhiều giá trị ngoại vi đặc biệt là ở các năm 1940, 1980, 2000.
- Tuy nhiên, đường xu hướng khá phẳng, cho thấy tốc độ giảm không lớn.
![Image](https://github.com/user-attachments/assets/def02686-d393-42bc-a1b4-8e9f064e7d0a)


Dòng chảy mùa khô (Jan–Apr) 
- Xu hướng giảm nhẹ của dòng chảy theo chỉ số Nino.
- Khi chỉ số Nino tăng (El Niño), dòng chảy mùa khô có xu hướng giảm.
- Điều này phù hợp với lý thuyết: El Niño thường gây ít mưa hơn ở một số khu vực Đông Nam Á trong mùa khô ( cụ thể ở đây là Thái Lan).
![Image](https://github.com/user-attachments/assets/6d541999-cfb0-4b66-9d9d-559bab394d63)


Dòng chảy mùa lũ (May–Dec) 
- Đường hồi quy gần như không có xu hướng rõ ràng. Đường hồi quy khá ngang, cho thấy không có mối quan hệ mạnh giữa Nino và dòng chảy mùa lũ ở khu vực này.
- Dòng chảy dao động mạnh từ dưới 100 đến hơn 800, không theo trật tự rõ ràng nào, có năm dòng chảy rất cao nhưng không trùng với giá trị Nino.
![Image](https://github.com/user-attachments/assets/b473bcd4-31d5-4f36-b85c-8820e5dfcfbe)


Dòng chảy trung bình năm  
- Có xu hướng tăng nhẹ theo chỉ số Nino, dữ liệu phân tán khá mạnh, có nhiều điểm dữ liệu lệch xa, đặc biết là những năm có dòng chảy trên 400m3/s.
- Đây là dấu hiệu cho thấy khu vực này có thể bị ảnh hưởng bởi các hiện tượng khí hậu toàn cầu như El Niño/La Niña, dù ảnh hưởng yếu.
![Image](https://github.com/user-attachments/assets/d84b1c19-8bb1-4715-8589-d2c7d054da09)
