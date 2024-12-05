/* eslint-disable react-native/no-inline-styles */
import React, { useState } from 'react'
import {
  LayoutAnimation,
  Platform,
  Text,
  UIManager,
  LogBox,
  SafeAreaView,
} from 'react-native'
import { TouchableOpacity } from 'react-native'
import { ScrollView } from 'react-native'
import { View } from 'react-native'
import { Dimensions } from 'react-native'

import { StyleSheet } from 'react-native'
import ImageGrid from '@baronha/react-native-image-grid'
import {
  openPicker,
  Result,
  defaultOptions,
  Config,
} from '@baronha/react-native-multiple-image-picker'
import { useImmer } from 'use-immer'
import { StatusBar } from 'expo-status-bar'

LogBox.ignoreAllLogs()

UIManager.setLayoutAnimationEnabledExperimental &&
  UIManager.setLayoutAnimationEnabledExperimental(true)

const layoutEffect = () => {
  LayoutAnimation.configureNext({
    duration: 350,
    create: {
      type: LayoutAnimation.Types.easeInEaseOut,
      property: LayoutAnimation.Properties.opacity,
    },
    update: {
      type: LayoutAnimation.Types.easeInEaseOut,
    },
  })
}

const { width } = Dimensions.get('window')

export default function App() {
  const [images, setImages] = useState<Result[]>([])
  const [options, setOptions] = useImmer<Config>(defaultOptions)

  const onPressImage = (item: Result, index: number) => {
    console.log(item, index)
  }

  const onPicker = async () => {
    try {
      const response = await openPicker({
        ...options,
        selectedAssets: Array.isArray(images) ? images : [images],
      })

      setImages(Array.isArray(response) ? response : [response])
      layoutEffect()
    } catch (e) {
      console.log('e: ', e)
    }
  }

  const onRemovePhoto = (_: Result, index: number) => {
    const data = [...images].filter((_, idx) => idx !== index)
    setImages(data)
  }

  return (
    <View style={style.container}>
      <SafeAreaView />
      {Platform.OS === 'android' && (
        <StatusBar
          translucent={false}
          networkActivityIndicatorVisible
          backgroundColor={'#000'}
        />
      )}

      <ScrollView>
        <View style={{ alignItems: 'center' }}>
          <ImageGrid
            dataImage={images}
            onPressImage={onPressImage}
            // spaceSize={10}
            containerStyle={{ marginTop: 3 }}
            width={Dimensions.get('window').width - 6}
            sourceKey={'path'}
            videoKey={'type'}
            prefixPath={Platform.OS === 'ios' ? 'file://' : ''}
            conditionCheckVideo={'video'}
            videoURLKey={'thumbnail'}
            showDelete
            onDeleteImage={onRemovePhoto}
          />

          <TouchableOpacity style={style.buttonOpen} onPress={onPicker}>
            <Text style={style.textOpen}>Open Picker</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </View>
  )
}

const style = StyleSheet.create({
  container: {
    backgroundColor: '#000',
    flex: 1,
  },
  title: {
    fontWeight: '900',
    fontSize: 24,
    paddingVertical: 24,
    fontFamily: 'Avenir',
    color: '#cdac81',
    textAlign: 'center',
  },
  buttonOpen: {
    margin: 24,
    backgroundColor: '#fff',
    padding: 12,
    alignItems: 'center',
    width: width - 48,
  },
  textOpen: {
    fontWeight: 'bold',
  },
  header: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    backgroundColor: 'rgba(0,0,0,0.9)',
  },
})
