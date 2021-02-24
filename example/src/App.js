/* eslint-disable react-native/no-inline-styles */
import React, { useState } from 'react';
import { Dimensions, Image, SafeAreaView, FlatList } from 'react-native';
import Video from 'react-native-video';
import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';
import MultipleImagePicker from '@baronha/react-native-multiple-image-picker';

export default function App() {
  const [images, setImages] = useState([]);

  const openPicker = async () => {
    try {
      const response = await MultipleImagePicker.openPicker({
        selectedAssets: images,
        // selectedColor: '#f9813a',
      });
      console.log('done: ', response);
      setImages(response);
    } catch (e) {
      console.log(e);
    }
  };

  const onDelete = (value) => {
    const data = images.filter(
      (item) =>
        item?.localIdentifier &&
        item?.localIdentifier !== value?.localIdentifier
    );
    setImages(data);
  };

  const renderItem = ({ item, index }) => {
    if (item?.type === 'image') {
      return (
        <View>
          <Image
            width={IMAGE_WIDTH}
            source={{ uri: 'file://' + item?.path }}
            style={style.media}
          />
          <TouchableOpacity
            onPress={() => onDelete(item)}
            activeOpacity={0.9}
            style={style.buttonDelete}
          >
            <Text style={style.titleDelete}>Xoá</Text>
          </TouchableOpacity>
        </View>
      );
    }
    if (item?.type === 'video') {
      return (
        <View>
          <Video
            bufferConfig={{
              minBufferMs: 1000,
              maxBufferMs: 5000,
              bufferForPlaybackMs: 2000,
              bufferForPlaybackAfterRebufferMs: 3000,
            }}
            controlAnimationTiming={1000}
            paused={index !== 0}
            playInBackground={false}
            repeat={true}
            resizeMode={'cover'}
            source={{ uri: item?.path }}
            disableBack
            disableFullscreen
            style={[style.media, { backgroundColor: '#000' }]}
            disableSeekbar
            disablePlayPause
            disableTimer
            disableVolume
            // onProgress={onProgress}
          />
          <TouchableOpacity
            onPress={() => onDelete(item)}
            activeOpacity={0.9}
            style={style.buttonDelete}
          >
            <Text style={style.titleDelete}>Xoá</Text>
          </TouchableOpacity>
        </View>
      );
    }
    return <View />;
  };

  return (
    <SafeAreaView style={style.container}>
      <FlatList
        style={[
          style.container,
          {
            paddingTop: 6,
          },
        ]}
        data={images}
        keyExtractor={(item, index) => (item?.filename ?? item?.path) + index}
        renderItem={renderItem}
        numColumns={3}
      />
      <TouchableOpacity style={style.openPicker} onPress={openPicker}>
        <Text style={style.openText}>open</Text>
      </TouchableOpacity>
    </SafeAreaView>
  );
}

const { width } = Dimensions.get('window');

const IMAGE_WIDTH = (width - 24) / 3;

const style = StyleSheet.create({
  container: {
    flex: 1,
  },
  imageView: {
    flex: 1,
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingVertical: 24,
  },
  media: {
    marginLeft: 6,
    width: IMAGE_WIDTH,
    height: IMAGE_WIDTH,
    marginBottom: 6,
    backgroundColor: 'rgba(0,0,0,0.2)',
  },
  openText: {
    fontWeight: 'bold',
    fontSize: 16,
  },
  openPicker: {
    flex: 1 / 3,
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonDelete: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    position: 'absolute',
    top: 6,
    right: 6,
    backgroundColor: '#ffffff92',
    borderRadius: 4,
  },
  titleDelete: {
    fontWeight: 'bold',
    fontSize: 12,
    color: '#000',
  },
});
