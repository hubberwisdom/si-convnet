#include <vector>

#include "caffe/data_layers.hpp"
#include <opencv2/highgui/highgui.hpp>

using std::string;

namespace caffe {

template <typename Dtype>
void BasePrefetchingDataLayer<Dtype>::Forward_gpu(
    const vector<Blob<Dtype>*>& bottom, vector<Blob<Dtype>*>* top) {
  // First, join the thread
  JoinPrefetchThread();
  // Copy the data
  caffe_copy(prefetch_data_.count(), prefetch_data_.cpu_data(),
      (*top)[0]->mutable_gpu_data());
  if (this->output_labels_) {
    caffe_copy(prefetch_label_.count(), prefetch_label_.cpu_data(),
        (*top)[1]->mutable_gpu_data());
  }
  // montage((*top)[0], "DataLayer");
  // cv::waitKey(0);

  // Start a new prefetch thread
  CreatePrefetchThread();
}

INSTANTIATE_CLASS(BasePrefetchingDataLayer);

}  // namespace caffe
